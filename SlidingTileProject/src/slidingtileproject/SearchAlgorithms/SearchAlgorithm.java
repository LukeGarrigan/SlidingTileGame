/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package slidingtileproject.SearchAlgorithms;

import slidingtileproject.State;

/**
 *
 * @author Luke
 */
public interface SearchAlgorithm {
    
    public State resolve(State start, State goal);
    
}
