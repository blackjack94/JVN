# 0. Import Linear Programming Tool
from scipy.optimize import linprog

# 1. Coefficients of the Objective Function
#    Negative coeffs due to Scipy's default of finding Min, not Max
c = [-0.22, -0.2, -0.18, -0.18]

# 2. Matrix of constraints' coefficients
A = [[62.5, 50, 0, 62.5],
     [75, 0, 100, 0],
     [62.5, 50, 75, 62.5],
     [50, 75, 75, 62.5],
     [0, 75, 0, 62.5]]

# 3. Upper-bound for each constraint
# b = [3750e3, 2000e3, 3375e3, 3500e3, 3750e3]  # For 4b)
b = [3750e3, 2000e3, 3375.1e3, 3500e3, 3750e3]  # For 4c)

# 4. Solve the Linear Program (default bound is non-negative)
res = linprog(c, A_ub=A, b_ub=b)

# 5. Print the results
print(f"MAX EARNINGS: {-1*res['fun']}\n")
print(f"Stir Fry: {res['x'][0]}")
print(f"Barbecue: {res['x'][1]}")
print(f"Hearty Mushrooms: {res['x'][2]}")
print(f"Veggie Crunch: {res['x'][3]}")
