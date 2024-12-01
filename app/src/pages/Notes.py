import streamlit as st
import requests
import logging

from modules.nav import SideBarLinks


logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks()


# Set the page title
st.title("Notepad")
st.write("\n\n")

department_id = st.session_state.get('department_ID', 1)


note_content = st.text_input("Add Note")

if st.button('Add Note', type='primary', use_container_width=True):
    if note_content:
        note_put = requests.post(f"http://api:4000/d/Note/{department_id}",json={"content": note_content})

note_get = requests.get(f'http://api:4000/d/Note/{department_id}').json()
st.write(note_get)