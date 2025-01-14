FROM nexus.frankframework.org/frank-framework:7.9-SNAPSHOT

# Copy Frank!
COPY --chown=tomcat configurations/ /opt/frank/configurations/
COPY --chown=tomcat tests/ /opt/frank/testtool/
COPY --chown=tomcat classes/ /opt/frank/resources/
COPY --chown=tomcat context.xml /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Copy dependencies
COPY --chown=tomcat lib/server/ /usr/local/tomcat/lib/
# COPY --chown=tomcat lib/webapp/ /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Compile custom class, this should be changed to a buildstep in the future (lombok.jar added to lib/server for now to be able to compile custom code with Lombo annotations)
COPY --chown=tomcat java /tmp/java
RUN javac \
      /tmp/java/nl/nn/adapterframework/http/HttpSenderBase.java \
      -classpath "/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/*:/usr/local/tomcat/lib/*" \
      -verbose -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes
RUN rm -rf /tmp/java

# Martijn May 2 2023: Copied from ZaakBrug and edited in a trivial way.
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
  CMD curl --fail --silent http://localhost/iaf/api/server/health || (curl --silent http://localhost/iaf/api/server/health && exit 1)