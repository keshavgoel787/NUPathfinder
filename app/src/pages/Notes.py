import streamlit as st
import requests
import logging
import pandas as pd 

from modules.nav import SideBarLinks


logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks()


# Set the page title
st.title("Notepad")
st.write("\n\n")

department_id = st.session_state.get('department_ID', 1)

note_get = requests.get(f'http://api:4000/d/Note/{department_id}').json()
content = []
noteID = []
for i in note_get:
    noteID.append(i['noteID'])
    content.append(i['content'])

df = pd.DataFrame(
        {
            'Note ID': noteID,
            'Content': content
        }
    )

st.dataframe(df, hide_index= True)


note_content = st.text_input("Add Note")

if st.button('Add Note', type='primary', use_container_width=True):
    if note_content:
        note_put = requests.post(f"http://api:4000/d/Note/{department_id}",json={"content": note_content})
        st.success("Successfully added note.")


with st.form("delete_note_form"):
    st.write("### Delete Notes")
    skill_to_delete = st.selectbox("Select Note to Delete", [i['noteID'] for i in note_get] if note_get else [], key='delete')
    delete_button = st.form_submit_button("Delete Note")

    if delete_button:
        if not skill_to_delete:
            st.warning("Please select a Note to delete.")
        else:
            try:
                response = requests.delete(f"http://api:4000/d/Note/{department_id}/{skill_to_delete}")
                response.raise_for_status()
                st.success("Successfully deleted note.")
                st.session_state['reload'] = True
            except requests.RequestException as err:
                logger.error(f"Error: {err}")
                st.error("Failed to delete note.")