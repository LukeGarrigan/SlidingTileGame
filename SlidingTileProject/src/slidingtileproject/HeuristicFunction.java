/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package slidingtileproject;

/**
 *
 * @author Luke
 */
public interface HeuristicFunction {

    public int calculateHeuristic(State state);

    public int calculateSingleHeuristic(State next);
}
