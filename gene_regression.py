import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm


#%%
df = pd.read_csv ("E:/CBD_python/hedgesg_genes.csv")
df.head()

df = df.dropna()
#%%

x = df[['FAAH', 'DRD2', 'HTR1A', 'CNR1']] #.values
y = df['mymean_est'] #.values
x, y = np.array(x), np.array(y)


x = sm.add_constant(x)
model = sm.OLS(y, x).fit()
predictions= model.predict(x)

print (model.summary())
model.conf_int(alpha=0.05, cols=None)

#%%
#Figure
sns.set(style='whitegrid', context='talk', rc={"grid.linewidth": 0.7})
sns.set_context("paper", font_scale=2)
plt.figure(figsize=(10, 5))

ax = sns.regplot(data=df, x="FAAH", y="mymean_est", ci=95, color='black', scatter_kws={'s':50})
ax.set_xlabel("FAAH mRNA microrray expression",fontsize=15)
ax.set_ylabel("Hedge's g effect-size estimate",fontsize=15)

plt.tight_layout()
plt.show()









