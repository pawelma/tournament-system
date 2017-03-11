module Tournament
  module Seeder
    class Random
      def initialize(random = nil)
        @random = random
      end

      def seed(teams)
        teams.shuffle(random: @random)
      end
    end
  end
end