# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st


#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Home.py", label="Home", icon="🏠")


def AboutPageNav():
    st.sidebar.page_link("pages/30_About.py", label="About", icon="🧠")


#### ------------------------ Role of Student ------------------------
def ProfileNav():
    st.sidebar.page_link(
        "pages/Profile.py", label="Profile", icon="👤"
    )


def JobListingNav():
    st.sidebar.page_link(
        "pages/Job_Listings.py", label="Job Listings", icon="🏢"
    )

####---------------------------Dhead Side bar --------------------------

def courseNav():
    st.sidebar.page_link('pages/ManageCourses.py', label = 'Manage Courses', icon = "✏️")

def notepad():
    st.sidebar.page_link('pages/Notes.py', label = 'Notepad', icon = "🗒️" )

def skillgaps():
    st.sidebar.page_link('pages/Skill_Analysis.py', label = 'View Skill Analysis', icon = "📈")


###---------------------------Listings Side bar --------------------------
def listingsNav():
    st.sidebar.page_link('pages/AddListings.py', label = 'Add Listing', icon = "➕")


###---------------------------Admin Side bar --------------------------
def test():
    st.sidebar.page_link('pages/Manage_Testing.py', label = 'Manage Testing', icon = "🧠")

def feedback():
     st.sidebar.page_link('pages/Manage_Feedback.py', label = 'Manage Feedback', icon = "🗒️")

def logs():
    st.sidebar.page_link('pages/View_DataLogs.py', label = 'View Datalogs', icon = "👁️")



###---------------------------Adding Side bar --------------------------
def addingNav():
    st.sidebar.page_link('pages/Listings.py', label = 'View Listings', icon = "👁️")






# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """

    # add a logo to the sidebar always
    st.sidebar.image("assets/logo.png", width=150)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        # Show the Home page link (the landing page)
        HomeNav()

    # Show the other page navigators depending on the users' role.
    if st.session_state["authenticated"]:

        # Show World Bank Link and Map Demo Link if the user is a political strategy advisor role.
        if st.session_state["role"] == "student":
            ProfileNav()
            JobListingNav()

        # If the user role is recrioter, show the recruiter
        if st.session_state["role"] == "recruiter":
            if st.session_state["recState"] == "listing":
                listingsNav()
            elif st.session_state["recState"] == "adding":
                addingNav()
            elif st.session_state["recState"] == "adding":
                listingsNav()
                addingNav()
        
        if st.session_state['role'] == 'Department_Head':
            courseNav()
            notepad()
            skillgaps()
        
        if st.session_state['role'] == 'administrator':
            test()
            feedback()
            logs()
            

    # Always show the About page at the bottom of the list of links
    AboutPageNav()


    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")
