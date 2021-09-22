x = 130.1
mu = 120
std = 21.21
N = 100
z = (x - mu) / (std/N**0.5)
import scipy.stats
zc = scipy.stats.norm.ppf(1-(0.05/2))

