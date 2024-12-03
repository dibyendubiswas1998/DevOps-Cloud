import streamlit as st
import numpy as np
import time

# Example-02:
# with st.chat_message("user"):
#     st.write("Hello 👋")
#     # st.chat_input("Enter Message: ")

########################################
# Example-02:
# message = st.chat_message("assistant")
# message.write("Hello human")
# message.bar_chart(np.random.randn(30, 3))

########################################
# Example-03:
# prompt = st.chat_input("Say something")
# if prompt:
#     st.write(f"User has sent the following prompt: {prompt}")

########################################
# Example-4:
st.header("Chat Bot 💬 📚")

# Initialize chat history
if "messages" not in st.session_state:
    st.session_state.messages = [
        {"role": "assistant", "content": "Ask me a question about Streamlit's open-source Python library!"}
    ]

# # Display chat messages from history on app rerun
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# React to user input or Get the User input
if prompt := st.chat_input("Ask Something"):
    # Display user message in chat message container
    with st.chat_message("user"):
        st.markdown(prompt)
    # Add user message to chat history
    st.session_state.messages.append({"role": "user", "content": prompt})

    # Get the Response or Generate the response:
    response = f"Echo: Hello there! How can I assist you today?"
    # Display assistant response in chat message container
    with st.chat_message("assistant"):
        st.markdown(response)
        
    # Add assistant response to chat history
    st.session_state.messages.append({"role": "assistant", "content": response})