# Baseball-Lineup-Optimizer
R model for optimizing a baseball lineup based on the starting pitcher

#### **Features:**

-   Uses historical player performance data to predict expected runs.
-   Applies machine learning and linear programming (`lpSolve`) to determine an optimal batting order.
-   Considers pitcher handedness (LHP/RHP) to adjust expected player performance.
-   Simulated dataset for proof of concept with customizable player statistics.

#### **Technologies Used:**

-   **R** (Tidyverse, lpSolve, caret)
-   **Linear Optimization** for lineup selection
-   **Probability-based Performance Estimation** based on OBP and AVG

#### **How It Works:**

1.  Loads player performance data against left and right-handed pitchers.
2.  Determines expected performance based on the starting pitcher.
3.  Runs an optimization model to create the highest-scoring lineup.
4.  Outputs the best batting order for maximum expected runs.
