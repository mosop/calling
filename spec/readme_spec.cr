require "./spec_helper"

module CallingReadmeSpecs
  module RecordingTimeNow
    TIME = Time.parse("20170129T123456+0900", "%Y%m%dT%H%M%S%z")

    module Recorded
      class Time
        extend Calling::Rec

        record_method :now, ::Time do
          TIME
        end
      end
    end

    it name do
      Recorded::Time.now.should eq TIME
      Recorded::Time.now(Time)[0][:result].should eq TIME
    end
  end

  module RecordingSleep
    SECONDS = 5_f64

    module Recorded
      extend Calling::Rec

      record_method :sleep, :any, {seconds: Float64} do
      end
    end

    it name do
      Recorded.sleep SECONDS
      Recorded.sleep(Calling::Any)[0][:args][:seconds].should eq SECONDS
    end
  end

  module ConditionalRecording
    SECONDS = 5_f64

    module Recorded
      extend Calling::NoRec

      record_method :sleep, :any, {seconds: Float64} do
        invoke seconds
      end

      def self.invoke(seconds)
        {result: seconds}
      end
    end

    it name do
      Recorded.sleep(SECONDS).should eq({result: SECONDS})
    end
  end
end
