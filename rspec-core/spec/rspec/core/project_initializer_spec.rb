require "spec_helper"
require 'rspec/core/project_initializer'

module RSpec::Core
  RSpec.describe ProjectInitializer, :isolated_directory => true do

    describe "#run" do
      context "with no args" do
        let(:command_line_config) { ProjectInitializer.new }

        before do
          allow(command_line_config).to receive(:puts)
          allow(command_line_config).to receive_messages(:gets => 'no')
        end

        context "with no .rspec file" do
          it "says it's creating .rspec " do
            expect(command_line_config).to receive(:puts).with(/create\s+\.rspec/)
            command_line_config.run
          end

          it "generates a .rspec" do
            command_line_config.run
            expect(File.read('.rspec')).to match(/--color\n--format progress/m)
          end
        end

        context "with a .rspec file" do
          it "says .rspec exists" do
            FileUtils.touch('.rspec')
            expect(command_line_config).to receive(:puts).with(/exist\s+\.rspec/)
            command_line_config.run
          end

          it "doesn't create a new one" do
            File.open('.rspec', 'w') {|f| f << '--color'}
            command_line_config.run
            expect(File.read('.rspec')).to eq('--color')
          end
        end

        context "with no spec/spec_helper.rb file" do
          it "says it's creating spec/spec_helper.rb " do
            expect(command_line_config).to receive(:puts).with(/create\s+spec\/spec_helper.rb/)
            command_line_config.run
          end

          it "generates a spec/spec_helper.rb" do
            command_line_config.run
            expect(File.read('spec/spec_helper.rb')).to match(/RSpec\.configure do \|config\|/m)
          end
        end

        context "with a spec/spec_helper.rb file" do
          before { FileUtils.mkdir('spec') }

          it "says spec/spec_helper.rb exists" do
            FileUtils.touch('spec/spec_helper.rb')
            expect(command_line_config).to receive(:puts).with(/exist\s+spec\/spec_helper.rb/)
            command_line_config.run
          end

          it "doesn't create a new one" do
            random_content = "content #{rand}"
            File.open('spec/spec_helper.rb', 'w') {|f| f << random_content}
            command_line_config.run
            expect(File.read('spec/spec_helper.rb')).to eq(random_content)
          end
        end

        context "with lib/tasks/rspec.rake" do
          before do
            FileUtils.mkdir_p('lib/tasks')
            FileUtils.touch 'lib/tasks/rspec.rake'
          end

          it "asks whether to delete the file" do
            expect(command_line_config).to receive(:puts).with(/delete/)
            command_line_config.run
          end

          it "removes it if confirmed" do
            allow(command_line_config).to receive_messages(:gets => 'yes')
            command_line_config.run
            expect(File.exist?('lib/tasks/rspec.rake')).to be_falsey
          end

          it "leaves it if not confirmed" do
            allow(command_line_config).to receive_messages(:gets => 'no')
            command_line_config.run
            expect(File.exist?('lib/tasks/rspec.rake')).to be_truthy
          end
        end
      end

      context "given an arg" do
        it "warns if arg received (no longer necessary)" do
          config = ProjectInitializer.new("another_arg")
          allow(config).to receive(:puts)
          allow(config).to receive_messages(:gets => 'no')
          config.run
        end
      end
    end
  end
end
