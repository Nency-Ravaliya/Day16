# Define the base image for your application
FROM nginx:latest

# Define your workdir as needed.
#WORKDIR /usr/share/nginx/html

# Copy the content from the local 'html' directory to the Nginx default directory
# We can add the ADD command for getting the remote file.
COPY html /usr/share/nginx/html

# Expose port 80 to access the web application
EXPOSE 80

# Start Nginx when the container starts, you can also add the Entrypoint here.
CMD ["nginx", "-g", "daemon off;"]
