import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')
st.session_state['authenticated'] = True

SideBarLinks(show_home=True)

logger.info("Loading the Home page of the app")
st.title('Warehouse Manager Portal')
st.write('\n\n')
st.write('### Reports')

if st.button('Show All Reorders', 
            type = 'primary', 
            use_container_width=True):
    st.switch_page('pages/41_Reorders.py')

if st.button('Show Low Stock', 
            type = 'primary', 
            use_container_width=True):
    st.switch_page('pages/42_Low_Stock.py')

st.write('\n\n')
st.write('### New Products and Categories')

if st.button('Show New Product Categories', 
            type = 'primary', 
            use_container_width=True):
    st.switch_page('pages/43_New_Cat.py')

if st.button('Show New Products', 
            type = 'primary', 
            use_container_width=True):
    st.switch_page('pages/44_New_Product.py')