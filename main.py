import streamlit as st
import plotly.express as px
import pandas as pd
import subprocess

def my_cache(f):
    @st.cache_data(max_entries=5, ttl=600)
    @functools.wraps(f)
    def inner(*args, **kwargs):
        return f(*args, **kwargs)
    return inner

@st.cache_data
def umap_plot_func(umap_data, colorby):
    return px.scatter(umap_data, x="umap_1", y="umap_2", color=colorby)

@st.cache_data
def load_data(rds):
    print(0)
    rds2 = rds.getvalue()
    with open("rds_file.rds", 'wb') as w:
        w.write(rds2)

    print(1)
    process = subprocess.Popen(["Rscript", "./organiod_integrin_expression.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    print(2)
    result = process.communicate()
    print(result)

def main():
    print("hi")
    rds = st.file_uploader("upload an .rds file")

    if rds != None:
        print("hi2")
        load_data(rds)
        print("hi3")
        umap_data = pd.read_csv("./umap_data.csv", index_col=0)

        integrin_expression_data = pd.read_csv("./integrin_expression.csv", index_col=0)

        colorby_options = list(umap_data.columns)
        colorby_options.remove('nCount_RNA')
        colorby_options.remove('nFeature_RNA')
        colorby_options.remove('umap_1')
        colorby_options.remove('umap_2')
        colorby_options.remove('cell_type')
        colorby_options = ['cell_type']+colorby_options
        
        colorby = st.selectbox('', colorby_options)

        umap_plot = st.plotly_chart(umap_plot_func(umap_data, colorby), key="umap", on_select="ignore")
        
        st.dataframe(integrin_expression_data)

main()
