require 'spec_helper'

describe Sunrise do
  it "should be valid" do
    Sunrise.should be_a(Module)
  end
  
  context "initializer sunrise.core.setup" do
    it "backend for ActiveSupport::XmlMini" do
      ActiveSupport::XmlMini.backend.should == ActiveSupport::XmlMini_Nokogiri
    end
    
    it "i18n backend should use sunrise I18nBackend " do
      I18n.backend.is_a?(Sunrise::Utils::I18nBackend).should be_true
    end
  end
end
