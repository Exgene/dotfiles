import gym
import numpy as np
from collections import defaultdict

# Create the environment (using 'FrozenLake-v1' as an example)
env = gym.make("FrozenLake-v1", is_slippery=False, render_mode="ansi")


# Policy: Selects actions randomly (initially, before learning)
def random_policy(state):
    return env.action_space.sample()


# Generate an episode using the given policy
def generate_episode(policy):
    episode = []
    state, info = env.reset(seed=42)
    terminated = False
    while not terminated:
        # Choose action based on the current policy
        action = policy(state)
        next_state, reward, terminated, truncated, info = env.step(action)
        episode.append((state, action, reward))
        state = next_state
    return episode


# First Visit Monte Carlo Prediction
def first_visit_mc_prediction(policy, env, num_episodes, gamma=0.99):
    # Initialize Q-value and returns dictionaries
    Q = defaultdict(lambda: np.zeros(env.action_space.n))
    returns_sum = defaultdict(float)
    returns_count = defaultdict(float)

    for _ in range(num_episodes):
        # Generate an episode
        episode = generate_episode(policy)
        visited_states = set()

        # Process the episode
        for t, (state, action, reward) in enumerate(episode):
            # First visit check
            if (state, action) not in visited_states:
                visited_states.add((state, action))
                # Compute the return (G_t) from step t
                G = sum(
                    [
                        reward * (gamma**i)
                        for i, (_, _, reward) in enumerate(episode[t:])
                    ]
                )
                # Update returns sum and count for the (state, action) pair
                returns_sum[(state, action)] += G
                returns_count[(state, action)] += 1
                # Update the Q-value for the (state, action) pair
                Q[state][action] = (
                    returns_sum[(state, action)] / returns_count[(state, action)]
                )

    return Q


# Derive the policy from Q-values (greedy policy)
def get_policy(Q):
    policy = {}
    for state, actions in Q.items():
        policy[state] = np.argmax(actions)  # Best action for this state
    return policy


# Render policy in a human-readable format
def render_policy(policy):
    env_desc = env.desc.astype(str)
    for state, action in policy.items():
        # Modify the environment description to show the policy's action
        env_desc[state // env.ncol, state % env.ncol] = ["<", "v", ">", "^"][action]
    print("\nLearned Policy:")
    print(env_desc)


# Apply First Visit Monte Carlo Prediction
Q = first_visit_mc_prediction(random_policy, env, num_episodes=10000, gamma=0.99)
policy = get_policy(Q)
render_policy(policy)

# Display the learned Q-values
print("\nFinal Q-values:")
for state, actions in Q.items():
    print(f"State {state}: {actions}")
