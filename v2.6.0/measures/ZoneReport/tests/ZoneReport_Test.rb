require 'openstudio'

require 'openstudio/ruleset/ShowRunnerOutput'

require "#{File.dirname(__FILE__)}/../measure.rb"

require 'test/unit'

# Override a bunch of OpenStudio methods so that we don't have to go through the trouble
# of creating a valid sql file - for now we can get away with a fake file that has no
# meaningful data
class OpenStudio::Model::Model
	def setSqlFile(sqlfile)
	end
end

class OpenStudio::Ruleset::OSRunner
	
	def lastEnergyPlusSqlFile
		FakeSqlFile.new
	end
	
	def setSqlFile(sqlFile)
	end
end

class OpenStudio::Model::ThermalZone

	def floorArea
		1800
	end
end

class FakeSqlFile
	def get
		self
	end
	
	def empty?
		false
	end
	
	def close
	end
	
	def execAndReturnFirstString(query)
		QueryResults.new(1.0)
	end
	
	def execAndReturnVectorOfString(query)
		QueryResults.new(["0"])
	end
end

class QueryResults
	def initialize(value)
		@value = value
	end

	def get
		@value
	end
	
	def empty?
		false
	end
end

class ZoneReport_Test < Test::Unit::TestCase

  # create test files if they do not exist
  def setup

    # create an instance of the measure
    @measure = ZoneReport.new

    #create an instance of the runner
    @runner = OpenStudio::Ruleset::OSRunner.new

    # Make an empty model
    @model = OpenStudio::Model::Model.new

    # get arguments
    @arguments = @measure.arguments()

    # make argument map
    @argument_map = OpenStudio::Ruleset::OSArgumentMap.new

    @runner.setLastOpenStudioModel(@model)
  end
  
  # Test that equipment present in the thermal zone is present in the output
  def test_HvacEquipmentPresentInOutput
	tz = OpenStudio::Model::ThermalZone.new(@model)
	tz.setName("Thermal Zone 1")
	
	# Add some representative equipment of each category
	tz.addEquipment(OpenStudio::Model::FanZoneExhaust.new(@model))
	tz.addEquipment(OpenStudio::Model::CoilHeatingElectric.new(@model, @model.alwaysOnDiscreteSchedule))
	tz.addEquipment(OpenStudio::Model::CoilCoolingDXSingleSpeed.new(@model))
	
	@measure.run(@runner, @argument_map)
	
	puts @runner.result.warnings.map { |e| e.logMessage }
	puts @runner.result.errors.map { |e| e.logMessage }
	assert_equal "Success", @runner.result.value.valueName
	
	zone_equip = @measure.zone_collection[0][:equipment]
	
	assert_equal OpenStudio::Model::CoilHeatingElectric.iddObjectType.valueName, zone_equip["Heating"][0]["Coil Type"]
	assert_equal OpenStudio::Model::FanZoneExhaust.iddObjectType.valueName, zone_equip["Fans"][0]["Fan Type"]
	assert_equal OpenStudio::Model::CoilCoolingDXSingleSpeed.iddObjectType.valueName, zone_equip["Cooling"][0]["Coil Type"]
  end

  
 # Test that equipment that is not specifically dealt with is still present in the output 
  def test_UnsupportedCoilsPresentInOutput
	tz = OpenStudio::Model::ThermalZone.new(@model)
	tz.setName("Thermal Zone 1")
	
	tz.addEquipment(OpenStudio::Model::CoilCoolingCooledBeam.new(@model))
	
	@measure.run(@runner, @argument_map)
	
	puts @runner.result.warnings.map { |e| e.logMessage }
	puts @runner.result.errors.map { |e| e.logMessage }
	assert_equal "Success", @runner.result.value.valueName
	
	zone_equip = @measure.zone_collection[0][:equipment]
	
	assert_equal OpenStudio::Model::CoilCoolingCooledBeam.iddObjectType.valueName, zone_equip["Cooling"][0]["Coil Type"]
  end

end
