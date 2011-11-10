module VCAP
  module Stager
    # Root of exception class hierarchy
    class Error < StandardError; end

    # A TaskError is a recoverable error that indicates any further task
    # processing should be aborted and the task should be completed in a failed
    # state. All other errors thrown during VCAP::Stager::Task#perform will be
    # logged and re-raised (probably causing the program to crash).
    class TaskError < Error
      class << self
        attr_reader :desc

        def set_desc(desc)
          @desc = desc
        end
      end

      attr_reader :details

      def initialize(details=nil)
        @details = details
      end

      def to_s
        @details ? "#{self.class.desc}:\n #{@details}" : self.class.desc
      end
    end
    class AppDownloadError     < TaskError; set_desc "Failed downloading application from the Cloud Controller";  end
    class AppUnzipError        < TaskError; set_desc "Failed unzipping application";                              end
    class StagingPluginError   < TaskError; set_desc "Staging plugin failed staging application";                 end
    class StagingTimeoutError  < TaskError; set_desc "Staging operation timed out";                               end
    class DropletCreationError < TaskError; set_desc "Failed creating droplet";                                   end
    class DropletUploadError   < TaskError; set_desc "Failed uploading droplet to the Cloud Controller";          end
    class InternalError        < TaskError; set_desc "Unexpected internal error encountered (possibly a bug).";   end

    # A PluginRunnerError occurs while the application is being staged inside of the container
    class PluginRunnerError             < TaskError;         set_desc "Failed running staging plugins"            end
    class MissingFrameworkPluginError   < PluginRunnerError; set_desc "Missing framework plugin";                 end
    class DuplicateFrameworkPluginError < PluginRunnerError; set_desc "Duplicate framework plugins specified";    end
    class UnknownPluginTypeError        < PluginRunnerError; set_desc "Unknown plugin type";                      end
    class StagingAbortedError           < PluginRunnerError; set_desc "Staging aborted";                          end
    class UnsupportedPluginError        < PluginRunnerError; set_desc "Unsupported plugin";                       end
  end
end
