/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package slidingtileproject;

import java.util.ArrayList;
import java.util.Arrays;

/**
 *
 * @author Luke
 */
public class SlidingTileProject {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here

        int[] twentyFiveMoves = new int[]{5, 1, 3, 4, 7, 2, 8, 12, 9, 6, 10, 0, 13, 14, 15, 11};
        int[] thirtyMoves = new int[]{5, 2, 1, 3, 7, 0, 8, 4, 9, 6, 10, 12, 13, 14, 15, 11};
        int[] thirtyFiveMoves = new int[]{5, 0, 2, 1, 7, 6, 8, 3, 9, 10, 15, 4, 13, 14, 11, 12};
        int[] fourtyMoves = new int[]{6, 7, 0, 11, 1, 5, 10, 4, 14, 13, 15, 2, 9, 8, 3, 12};
        int[] fiftyMoves = new int[]{1, 3, 11, 14, 6, 2, 5, 0, 15, 4, 13, 9, 12, 10, 7, 8};
        int[] sixtyFiveMoves = new int[]{11, 14, 9, 15, 7, 2, 8, 13, 3, 0, 5, 6, 12, 1, 10, 4};
        int[] quickTest = new int[]{2, 9, 14, 0, 4, 7, 5, 6, 15, 1, 3, 13, 10, 11, 12, 8};

        HeuristicFunction h = new Manhattan();
        HeuristicFunction l = new LinearConflict();
        IterativeDeepeningAStar ida = new IterativeDeepeningAStar(l);

        State initialState = new State(twentyFiveMoves, 0, 0, null, "null");
        int intialHeuristic = l.calculateHeuristic(initialState);
        initialState.setH(intialHeuristic);

        System.out.println("");
        double startTime = System.currentTimeMillis();
        State goal = ida.resolve(initialState);
        double endTime = System.currentTimeMillis();
        double elapsedTime = endTime - startTime;
        System.out.println(elapsedTime / 1000 + "(s)");
        System.out.println(Arrays.toString(goal.getState()));
        
    }

}
