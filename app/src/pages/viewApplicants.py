import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')


applicants = requests.get(f"http://api:4000/r/applicants/{st.session_state['applicant_job_id']}").json()

stIdArr =[]
firstArr = []
lastArr = []
majorArr = []
matchArr = []
statusArr = []
dateArr = []

for i in applicants:
    stIdArr.append(i['studentId'])
    firstArr.append(i['firstName'])
    lastArr.append(i['lastName'])
    majorArr.append(i['major'])
    matchArr.append(i['matchPercent'])
    statusArr.append(i['status'])
    dateArr.append(i['dateOfApplication'][5:17])

data = {
    "Id" : stIdArr,
    "First Name" : firstArr,
    "Last Name" : lastArr,
    "Major" : majorArr,
    "Match Percent" : matchArr,
    "Application Status" : statusArr,
    "Date of Application" : dateArr
}



# Convert data to DataFrame
df = pd.DataFrame(data) #, columns = ("First Name", "Last Name", "Major", "Match Percent", "Application Status", "Date of Application"))

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

if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")

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

        student_id = row['Id']
        studentSkills = requests.get(f"http://api:4000/r/applicants/skills/{student_id}").json()

        st.write("**Skills:**")
        for skill in studentSkills:
            st.write(f"- {skill['name']} || {'⭐' * skill['proficiency']}")
        if st.button("Blacklist student", key = f"profile-{student_id}"):
            try:
                    url = f"http://api:4000/r/blackList"
                    data = {
                        'studentId': row['Id'],
                        'recId': st.session_state["rec_id"]
                    }
                    response = requests.post(url, json=data)
                    if response.status_code == 200:
                        st.success("student added successfully!")
                    else:
                        st.error(f"Error adding listing: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")

            url = f"http://api:4000/r/Listings/{st.session_state['rec_id']}"

            listings = requests.get(url).json()

            for i in listings:
                response2 = requests.delete(f"http://api:4000/r/removeApp/{i['jobId']}/{row['Id']}")
                st.success("student removed successfully!")
            st.switch_page("pages/viewApplicants.py")