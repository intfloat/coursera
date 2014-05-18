class RockPaperScissors

  # Exceptions this class can raise:
  class NoSuchStrategyError < StandardError ; end

  def self.winner(player1, player2)
    # YOUR CODE HERE
    w = ["RS", "PR", "SP"];
    valid = ["R", "P", "S"];
    if w.index(player1[1].upcase + player2[1].upcase)
    	return player1
    elsif !valid.index(player1[1].upcase) or !valid.index(player2[1].upcase)
    	raise RockPaperScissors::NoSuchStrategyError,"Strategy must be one of R,P,S"
    elsif player1[1].upcase == player2[1].upcase
    	return player1
    else
    	return player2
    end    	
  end

  def self.tournament_winner(tournament)
    # YOUR CODE HERE
    if tournament[0][0].class.to_s == "String"
    	return self.winner(tournament[0], tournament[1])
    end
    if tournament.length == 1
    	p1 = self.winner(tournament[0][0][0], tournament[0][0][1])
    	p2 = self.winner(tournament[0][1][0], tournament[0][1][1])
    	return self.winner(p1, p2)
    end
    len = tournament.length
    # recursively solve the problem    
    p1 = self.tournament_winner(tournament.slice(0, len/2))
    p2 = self.tournament_winner(tournament.slice(len/2, len/2))    
    self.winner(p1, p2)
  end

end
