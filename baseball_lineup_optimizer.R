library(tidyverse)
library(caret)
library(lpSolve)

# Simulated dataset with player stats vs pitcher types
set.seed(123)
player_data <- data.frame(
  player = paste("Player", 1:9),
  avg_vs_left = runif(9, .200, .350),  # Batting avg vs LHP
  avg_vs_right = runif(9, .200, .350), # Batting avg vs RHP
  obp_vs_left = runif(9, .300, .450),  # OBP vs LHP
  obp_vs_right = runif(9, .300, .450)  # OBP vs RHP
)

# Simulate a starter pitcher (Left or Right Handed)
starting_pitcher <- data.frame(
  handedness = sample(c("L", "R"), 1)
)

# Select player performance based on pitcher handedness
if (starting_pitcher$handedness == "L") {
  player_data <- player_data %>% mutate(exp_runs = (avg_vs_left + obp_vs_left) / 2)
} else {
  player_data <- player_data %>% mutate(exp_runs = (avg_vs_right + obp_vs_right) / 2)
}

# Lineup Optimization using lpSolve
num_players <- nrow(player_data)
costs <- -player_data$exp_runs  # Negative for maximization

# Constraint matrix for lineup positioning
const_mat <- diag(num_players)
const_dir <- rep("=", num_players)
const_rhs <- rep(1, num_players)

# Ensure each player is assigned exactly one slot in the lineup
lineup_constraints <- matrix(0, nrow = num_players, ncol = num_players)
for (i in 1:num_players) {
  lineup_constraints[i, i] <- 1
}
const_mat <- rbind(const_mat, lineup_constraints)
const_dir <- c(const_dir, rep("=", num_players))
const_rhs <- c(const_rhs, rep(1, num_players))

solution <- lp(
  direction = "min",
  objective.in = costs,
  const.mat = const_mat,
  const.dir = const_dir,
  const.rhs = const_rhs,
  all.bin = TRUE
)

if (solution$status == 0) {
  optimal_lineup <- player_data[solution$solution == 1, ]
  optimal_lineup <- optimal_lineup %>% arrange(desc(exp_runs)) %>% mutate(slot = row_number())
  print(optimal_lineup)
} else {
  print("Optimization failed. Check constraints and input data.")
}
