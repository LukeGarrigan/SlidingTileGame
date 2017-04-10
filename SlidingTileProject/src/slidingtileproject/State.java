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
public class State {

    private int[] state;
    private float g, h, f;
    private State previousState;
    private String direction;
    private int zeroPosition;
    private int movedPosition;
    private int[] heuristicArray;

    public State(int[] state, float g, float h, State previousState, String direction) {
        this.state = state;
        this.g = g;
        this.h = h;
        this.previousState = previousState;
        this.direction = direction;
        if (previousState != null) {
            this.heuristicArray = previousState.getHeuristicArray();
        } else {
            // first state so we need to find zero position
            this.zeroPosition = findZeroPosition();
        }
    }

    public int findZeroPosition() {
        int position = 0;
        for (int i = 0; i < state.length; i++) {
            if (state[i] == 0) {
                position = i;
                break;
            }
        }
        return position;
    }

    public int[] getHeuristicArray() {
        return heuristicArray;
    }

    public void setHeuristicArray(int[] heuristicArray) {
        this.heuristicArray = heuristicArray;
    }

    public int getMovedPosition() {
        return movedPosition;
    }

    public void setMovedPosition(int movedPosition) {
        this.movedPosition = movedPosition;
    }

    public int getZero() {
        return zeroPosition;
    }

    public float getG() {
        return g;
    }

    public float getH() {
        return h;
    }

    public float getF() {
        return f;
    }

    public State getPreviousState() {
        return previousState;
    }

    public String getDirection() {
        return this.direction;
    }

    public void updateDirection(String direction) {
        this.direction = direction;
    }

    public State getPrevious() {
        return this.previousState;
    }

    public int[] getState() {
        return this.state;
    }

    public float getFScore() {
        return this.f;
    }

    public void setState(int[] state) {
        this.state = state;
    }

    public void setG(float g) {
        this.g = g;
    }

    public void setH(float h) {
        this.h = h;
    }

    public void setF(float f) {
        this.f = f;
    }

    public void setPreviousState(State previousState) {
        this.previousState = previousState;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public float getGScore() {
        return this.g;
    }

    public void setZeroPosition(int pos) {
        this.zeroPosition = pos;
    }

    public ArrayList<State> findNeighbours() {

        ArrayList<State> neighbours = new ArrayList<>();
        if (zeroPosition % 4 != 0 && !direction.equals("right")) {
            int[] left = new int[16];
            System.arraycopy(state, 0, left, 0, left.length);
            int temp = left[zeroPosition];
            left[zeroPosition] = left[zeroPosition - 1];
            left[zeroPosition - 1] = temp;
            State newState = new State(left, 0, h, this, "left");
            newState.setMovedPosition(zeroPosition);
            newState.setZeroPosition(zeroPosition - 1);
            neighbours.add(newState);

        }
        if (zeroPosition % 4 != 3 && !direction.equals("left")) {
            int[] right = new int[16];
            System.arraycopy(state, 0, right, 0, right.length);

            int temp = right[zeroPosition];
            right[zeroPosition] = right[zeroPosition + 1];
            right[zeroPosition + 1] = temp;
            State newState = new State(right, 0, h, this, "right");
            newState.setMovedPosition(zeroPosition);
            newState.setZeroPosition(zeroPosition + 1);
            neighbours.add(newState);

        }
        // GOING UP
        if (zeroPosition > 3 && !direction.equals("down")) {

            int[] up = new int[16];
            System.arraycopy(state, 0, up, 0, up.length);
            int temp = up[zeroPosition];
            up[zeroPosition] = up[zeroPosition - 4];
            up[zeroPosition - 4] = temp;
            State newState = new State(up, 0, h, this, "up");
            newState.setMovedPosition(zeroPosition);
            newState.setZeroPosition(zeroPosition - 4);
            neighbours.add(newState);

        }
        // GOING DOWN
        if (zeroPosition < 12 && !direction.equals("up")) {
            int[] down = new int[16];
            System.arraycopy(state, 0, down, 0, down.length);
            int temp = down[zeroPosition];
            down[zeroPosition] = down[zeroPosition + 4];
            down[zeroPosition + 4] = temp;
            State newState = new State(down, 0, h, this, "down");
            newState.setMovedPosition(zeroPosition);
            newState.setZeroPosition(zeroPosition + 4);
            neighbours.add(newState);
        }
        // }
        return neighbours;
    }

    /*
    public ArrayList<State> findNeighbours() {

        ArrayList<State> neighbours = new ArrayList<>();
        for (int i = 0; i < state.length; i++) {
            if (state[i] == 0) {
                if (i % 4 != 0 && !direction.equals("right")) {
                    int[] left = new int[16];
                    System.arraycopy(state, 0, left, 0, left.length);
                    int temp = left[i];
                    left[i] = left[i - 1];
                    left[i - 1] = temp;
                    State newState = new State(left, 0, 0, this, "left");
                    neighbours.add(newState);

                }
                if (i % 4 != 3 && !direction.equals("left")) {
                    int[] right = new int[16];
                    System.arraycopy(state, 0, right, 0, right.length);

                    int temp = right[i];
                    right[i] = right[i + 1];
                    right[i + 1] = temp;
                    State newState = new State(right, 0, 0, this, "right");
                    neighbours.add(newState);

                }
                if (i > 3 && !direction.equals("down")) {

                    int[] up = new int[16];
                    System.arraycopy(state, 0, up, 0, up.length);
                    int temp = up[i];
                    up[i] = up[i - 4];
                    up[i - 4] = temp;
                    State newState = new State(up, 0, 0, this, "up");
                    neighbours.add(newState);

                }
                if (i < 12 && !direction.equals("up")) {
                    int[] down = new int[16];
                    System.arraycopy(state, 0, down, 0, down.length);
                    int temp = down[i];
                    down[i] = down[i + 4];
                    down[i + 4] = temp;
                    State newState = new State(down, 0, 0, this, "down");
                    neighbours.add(newState);

                }

            }
        }
        return neighbours;
    }
     */
    @Override
    public boolean equals(Object o) {
        return (o instanceof State) && Arrays.equals(((State) o).state, state);
    }

    @Override
    public int hashCode() {
        return state.hashCode();
    }

    public void printHeuristicArray() {
        for (int i = 0; i < heuristicArray.length; i++) {
            System.out.print(heuristicArray[i] + " ");
            if ((i + 1) % 4 == 0) {
                System.out.println();
            }
        }
    }

    public void printState() {
        for (int i = 0; i < state.length; i++) {
            System.out.print(state[i] + " ");
            if ((i + 1) % 4 == 0) {
                System.out.println();
            }
        }
    }
}
