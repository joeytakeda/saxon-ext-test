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
        LIST.put("fi", "finnish");
        LIST.put("el", "greek");
        LIST.put("hi","hindi");
        LIST.put("hu", "hungarian");
        LIST.put("id", "indonesian");
        LIST.put("ga", "irish");
        LIST.put("it", "italian");
        LIST.put("lt", "lithuanian");
        // Nepali?
        LIST.put("no", "norwegian");
        LIST.put("pt", "portuguese");
        LIST.put("ro", "romanian");
        LIST.put("ru", "russian");
        LIST.put("sr", "serbian");
        LIST.put("es", "spanish");
        LIST.put("sv", "swedish");
        LIST.put("ta", "tamil");
        LIST.put("tr", "turkish");
        LIST.put("yi", "yiddish");
    }
    
    public String get(String key){
        if (LIST.containsKey(key)){
            return LIST.get(key);
        } else {
            return "UNKNOWN";
        }
    }
}