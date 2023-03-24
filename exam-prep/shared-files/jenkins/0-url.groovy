import jenkins.model.*

// Read the environment variable
url = 'http://192.168.99.101:8080'

// Get the config from our running instance
urlConfig = JenkinsLocationConfiguration.get()

// Set the config to be the value of the env var
urlConfig.setUrl(url)

// Save the configuration
urlConfig.save()

// Print the results
println("Jenkins URL Set to " + url)
