import pandas as pd
pd.set_option('display.float_format', lambda x: '%.6f' % x)

data = pd.read_csv('Data//Roadmap_Networks//adj_matrix//' + 'breast_variant_human_mammary_epithelial_cells_vhmec.txt', sep=" ", header = None)
data = data.astype(float)
data.round(6)

print(data)

data.to_csv('Data//Roadmap_Networks//adj_matrix_2//' + 'breast_variant_human_mammary_epithelial_cells_vhmec.txt', index = False, sep = " ", header = None, float_format='%.6f')