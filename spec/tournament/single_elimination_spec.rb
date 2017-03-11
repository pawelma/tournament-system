describe Tournament::SingleElimination do
  describe '#total_rounds' do
    it 'works for valid input' do
      driver = TestDriver.new(teams: [1, 2, 3])
      expect(described_class.total_rounds driver).to eq(2)

      driver = TestDriver.new(teams: [1, 2])
      expect(described_class.total_rounds driver).to eq(1)

      driver = TestDriver.new(teams: [1])
      expect(described_class.total_rounds driver).to eq(0)

      driver = TestDriver.new(teams: (1..9).to_a)
      expect(described_class.total_rounds driver).to eq(4)
    end
  end

  describe '#generate' do
    context 'first round' do
      it 'works for 4 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4])
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(2)
        match1, match2 = driver.created_matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to eq(3)
        expect(match2.home_team).to eq(2)
        expect(match2.away_team).to eq(4)
      end

      it 'works for 5 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5])
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(4)
        match1, match2, match3, match4 = driver.created_matches
        bies = [2, 4, 3]
        [match1, match2, match3].zip(bies).each do |match, team|
          expect(match.home_team).to eq(team)
          expect(match.away_team).to be nil
        end

        expect(match4.home_team).to eq(1)
        expect(match4.away_team).to eq(5)
      end

      it 'works for 16 teams' do
        driver = TestDriver.new(teams: (1..16).to_a)
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(8)
        matches = [
          [1, 9],
          [5, 13],
          [3, 11],
          [7, 15],
          [2, 10],
          [6, 14],
          [4, 12],
          [8, 16],
        ]
        driver.created_matches.zip(matches).each do |match, teams|
          expect(match.home_team).to eq(teams[0])
          expect(match.away_team).to eq(teams[1])
        end
      end
    end

    context 'full tournament' do
      it 'works for 4 teams' do
        winners = { [1, 3] => 3, [2, 4] => 2, [3, 2] => 2 }
        driver = TestDriver.new(teams: (1..4).to_a, winners: winners)

        (1..2).each do |round|
          described_class.generate driver, round: round
          driver.test_matches[round] = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          driver.created_matches = []
        end

        expect(driver.matches.length).to eq(3)
      end
    end
  end
end