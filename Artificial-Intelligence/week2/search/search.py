# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
#
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print "Start:", problem.getStartState()
    print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    print "Start's successors:", problem.getSuccessors(problem.getStartState())
    """
    "*** YOUR CODE HERE ***"
    if problem.isGoalState(problem.getStartState()): return []
    st, mp, expanded = util.Stack(), {}, set()
    st.push(problem.getStartState())
    mp[problem.getStartState()] = None
    while not st.isEmpty():
        tp = st.pop()
        if tp in expanded: continue
        expanded.add(tp)
        if problem.isGoalState(tp):
            res, cur = [], tp
            while cur in mp and cur != problem.getStartState():
                res.append(mp[cur][1])
                cur = mp[cur][0]
                # print cur
            return res[::-1]
        # print 'current state:', tp
        for suc, act, cost in problem.getSuccessors(tp):
            if suc not in mp: st.push(suc)
            if suc not in expanded: mp[suc] = (tp, act)

    util.raiseNotDefined()

def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    q, mp = util.Queue(), {}
    q.push(problem.getStartState())
    mp[problem.getStartState()] = None
    while not q.isEmpty():
        tp = q.pop()
        # print 'current state:', tp
        if problem.isGoalState(tp):
            res, cur = [], tp
            while cur in mp and mp[cur]:
                res.append(mp[cur][1])
                cur = mp[cur][0]
            return res[::-1]
        for suc, act, cost in problem.getSuccessors(tp):
            if suc not in mp:
                q.push(suc)
                mp[suc] = (tp, act)
    util.raiseNotDefined()

def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"
    q, mp = util.PriorityQueueWithFunction(lambda e: e[1]), {}
    q.push((problem.getStartState(), 0))
    mp[problem.getStartState()] = (problem.getStartState(), None, 0)
    while not q.isEmpty():
        tp, cst = q.pop()
        if mp[tp][2] < cst:
            continue
        # print 'current state:', tp
        if problem.isGoalState(tp):
            res, cur = [], tp
            while cur in mp and mp[cur][0] != cur:
                res.append(mp[cur][1])
                cur = mp[cur][0]
            return res[::-1]
        for suc, act, cost in problem.getSuccessors(tp):
            if suc not in mp or mp[suc][2] > cost + cst:
                q.push((suc, cost + cst))
                mp[suc] = (tp, act, cost + cst)
    util.raiseNotDefined()

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    q, mp = util.PriorityQueueWithFunction(lambda e: e[1] + e[2]), {}
    start = problem.getStartState()
    q.push((start, 0, heuristic(start, problem)))
    mp[start] = (start, None, heuristic(start, problem))
    expanded = set()
    while not q.isEmpty():
        tp, g, h = q.pop()
        if problem.isGoalState(tp):
                res, cur = [], tp
                while cur in mp and cur != start:
                    res.append(mp[cur][1])
                    cur = mp[cur][0]
                return res[::-1]
        if tp in expanded: continue
        expanded.add(tp)
        for suc, act, cost in problem.getSuccessors(tp):
            total = cost + g + heuristic(suc, problem)
            q.push((suc, g + cost, heuristic(suc, problem)))
            # if suc not in mp:
            if suc not in mp or mp[suc][2] >= total: mp[suc] = (tp, act, total)
    util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
