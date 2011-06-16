# Use this hook to configure sunrise
if Object.const_defined?("Sunrise")
  Sunrise.setup do |config|
    # Flash keys
    #config.flash_keys = [ :success, :failure ]
  end
end
