# mssql-server-rhel
# Maintainers: Travis Wright (twright-msft on GitHub)
# GitRepo: https://github.com/twright-msft/mssql-server-rhel

# Base OS layer: latest RHEL 7
FROM registry.access.redhat.com/rhel7/rhel:latest

ARG SA_PASSWORD='StrongP@ssW0rd'

ENV ACCEPT_EULA=Y MSSQL_PID=Developer MSSQL_SA_PASSWORD=$REPO

# Install latest mssql-server package
# You don't have to register subscription if you build docker image on registered RHEL machine.
# If you build on other machines, please fill in Red Hat subscription name and password and uncomment the below command.
#RUN subscription-manager register --username <your_username> --password <your_password> --auto-attach
RUN yum install -y curl
RUN curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo && curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
RUN yum install -y mssql-server mssql-server-agent mssql-server-fts
RUN yum install -y mssql-tools unixODBC-devel

# Default SQL Server TCP/Port
EXPOSE 1433

RUN /opt/mssql/bin/mssql-conf -n setup accept-eula

ENV PATH $PATH:/opt/mssql-tools/bin
