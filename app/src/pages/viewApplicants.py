import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')


applicants = requests.get(f"http://api:4000/r/applicants/{st.session_state['applicant_job_id']}").json()


firstArr = []
lastArr = []
majorArr = []
matchArr = []
statusArr = []
dateArr = []

for i in applicants:
    firstArr.append(i['firstName'])
    lastArr.append(i['lastName'])
    majorArr.append(i['major'])
    matchArr.append(i['matchPercent'])
    statusArr.append(i['status'])
    dateArr.append(i['dateOfApplication'][5:17])

data = {
    "First Name" : firstArr,
    "Last Name" : lastArr,
    "Major" : majorArr,
    "Match Percent" : matchArr,
    "Application Status" : statusArr,
    "Date of Application" : dateArr
}



# Convert data to DataFrame
df = pd.DataFrame(data)

# Streamlit UI
st.subheader(f"Job Applicants Dashboard for {st.session_state['applicant_job_name']}.")

# Filters
st.sidebar.header("Filter Applicants")
status_filter = st.sidebar.multiselect(
    "Application Status",
    options=df["Application Status"].unique(),
    default=df["Application Status"].unique(),
)

sort_by = st.sidebar.selectbox(
    "Sort By",
    ["Match Percent", "Date of Application"],
    index=0,
)

# Filter and sort data
filtered_df = df[df["Application Status"].isin(status_filter)]
sorted_df = filtered_df.sort_values(by=sort_by, ascending=(sort_by != "Match Percent"))

# Display the table
st.subheader("Applicants Overview")
st.dataframe(sorted_df, hide_index = True)

# Applicant details
st.subheader("Detailed View")
for _, row in sorted_df.iterrows():
    with st.expander(f"{row['First Name']} {row['Last Name']}"):
        st.write(f"**Major:** {row['Major']}")
        st.write(f"**Match Percent:** {row['Match Percent']}%")
        st.write(f"**Application Status:** {row['Application Status']}")
        st.write(f"**Date of Application:** {row['Date of Application']}")


        applicants = requests.get(f"http://api:4000/r/applicants/{st.session_state['applicant_job_id']}").json()
        #add skills