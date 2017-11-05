# mssql-server-rhel
# Maintainers: Travis Wright (twright-msft on GitHub)
# GitRepo: https://github.com/twright-msft/mssql-server-rhel

# Base OS layer: latest RHEL 7
FROM registry.access.redhat.com/rhel7/rhel:latest

# For SQLCMD installation
ENV ACCEPT_EULA=Y 

# Install latest mssql-server package
# You don't have to register subscription if you build docker image on registered RHEL machine.
# If you build on other machines, please fill in Red Hat subscription name and password and uncomment the below command.
#RUN subscription-manager register --username <your_username> --password <your_password> --auto-attach
RUN yum install -y curl
RUN curl https://packages.microsoft.com/config/rhel/7/mssql-server.repo > /etc/yum.repos.d/mssql-server.repo
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
RUN yum install -y mssql-server mssql-server-agent mssql-server-fts
RUN yum install -y mssql-tools 

# Default SQL Server TCP/Port
EXPOSE 1433

#Import the sqlservr.sh script
ADD ./sqlservr.sh /opt/mssql/bin/
RUN chmod a+x /opt/mssql/bin/sqlservr.sh

# Run SQL Server process
CMD /bin/bash /opt/mssql/bin/sqlservr.sh

ENV PATH $PATH:/opt/mssql-tools/bin
