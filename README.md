# Tournament System

[![Build Status](https://travis-ci.org/ozfortress/tournament-system.svg?branch=master)](https://travis-ci.org/ozfortress/tournament-system)
[![Coverage Status](https://coveralls.io/repos/github/ozfortress/tournament-system/badge.svg?branch=master)](https://coveralls.io/github/ozfortress/tournament-system?branch=master)
[![Gem Version](https://badge.fury.io/rb/tournament-system.svg)](https://badge.fury.io/rb/tournament-system)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/ozfortress/tournament-system/master)

This is a simple gem that implements numerous tournament systems.

It is designed to easily fit into any memory model you might already have.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tournament-system', '~> 1.0.0'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install tournament-system
```

## Usage

First you need to implement a driver to handle the interface between your data
and the tournament systems:

```ruby
class Driver < TournamentSystem::Driver
  def matches
    ...
  end

  def seeded_teams
    ...
  end

  def ranked_teams
    ...
  end

  def get_match_winner(match)
    ...
  end

  def get_match_teams(match)
    ...
  end

  def get_team_score(team)
    ...
  end

  def build_match(home_team, away_team)
    ...
  end
end
```

Then you can simply generate matches for any tournament system using a driver
instance:

```ruby
driver = Driver.new

# Generate a round of a single elimination tournament
TournamentSystem::SingleElimination.generate driver

# Generate a round for a round robin tournament
TournamentSystem::RoundRobin.generate driver

# Generate a round for a swiss system tournament, pushing byes to the bottom
#  half (bottom half teams will bye before the top half)
TournamentSystem::Swiss.generate driver, pairer: TournamentSystem::Swiss::Dutch,
                                   pair_options: { push_byes_to: :bottom_half }

# Generate a round for a page playoff system, with an optional bronze match
TournamentSystem::PagePlayoff.generate driver, bronze_match: true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/ozfortress/tournament-system.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
