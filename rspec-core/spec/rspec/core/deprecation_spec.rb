require "spec_helper"

describe RSpec::Core::Deprecation do
  describe "#deprecate" do
    context "old API with individual args" do
      it "includes the method to deprecate" do
        expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :method => "deprecated_method")
        RSpec.deprecate("deprecated_method")
      end

      it "includes the replacement when provided" do
        expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :method => "deprecated_method", :alternate_method => "replacement")
        RSpec.deprecate("deprecated_method", "replacement")
      end

      it "adds the call site" do
        expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :called_from => caller(0)[1])
        RSpec.deprecate("deprecated_method")
      end
    end

    context "new API with a hash" do
      it "passes the hash to the reporter" do
        expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :method => "deprecated_method", :alternate_method => "replacement")
        RSpec.deprecate(:method => "deprecated_method", :alternate_method => "replacement")
      end

      it "adds the call site" do
        expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :called_from => caller(0)[1])
        RSpec.deprecate(:method => "deprecated_method")
      end
    end
  end
end
