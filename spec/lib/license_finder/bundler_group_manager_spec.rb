require "spec_helper"

module LicenseFinder
  describe BundlerGroupManager do
    let(:config) { Configuration.new }

    before do
      LicenseFinder.stub(:config).and_return config
      config.ignore_groups = ignore_groups
    end

    describe ".add_ignored_group" do
      describe "when the group is already ignored" do
        let(:ignore_groups) { ["test", "other_group"] }

        it "does not create a duplicate entry" do
          config.should_not_receive(:save_to_yaml)

          described_class.add_ignored_group("test")
        end
      end

      describe "when the group is not ignored" do
        let(:ignore_groups) { [] }

        it "adds the group to the ignored bundler groups" do
          config.should_receive(:save_to_yaml)

          described_class.add_ignored_group("test")

          config.ignore_groups.should include(:test)
        end
      end
    end

    describe ".remove_ignored_group" do
      describe "when the group is not ignored" do
        let(:ignore_groups) { [] }

        it "does not call save_to_yaml on config" do
          config.should_not_receive(:save_to_yaml)

          described_class.remove_ignored_group("test")
        end
      end

      describe "when the group is already ignored" do
        let(:ignore_groups) { ["test", "other_group"] }

        it "removes the group from the ignored bundler group list" do
          config.should_receive(:save_to_yaml)

          described_class.remove_ignored_group("test")

          config.ignore_groups.should_not include(:test)
        end
      end
    end
  end
end
