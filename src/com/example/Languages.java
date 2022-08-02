package com.example;

import java.util.HashMap;

public class Languages{
    
    static HashMap<String, String> LIST = new HashMap<String, String>();
    
    static{
        LIST.put("ar", "arabic");
        LIST.put("hy","armenian");
        LIST.put("eu","basque");
        LIST.put("ca", "catalan");
        LIST.put("da","danish");
        LIST.put("nl","dutch");
        LIST.put("en", "english");
        LIST.put("fr","french");
        LIST.put("de","german");
    }
    
    public String get(String key){
        if (LIST.containsKey(key)){
            return LIST.get(key);
        } else {
            return "UNKNOWN";
        }
    }
}