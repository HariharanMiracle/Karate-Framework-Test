package examples.application;

import com.intuit.karate.junit5.Karate;

class ApplicationsRunner {
    
    @Karate.Test
    Karate testApplications() {
        return Karate.run("applications").relativeTo(getClass());
    }    

}
