package com.example;

import java.util.HashMap;
import java.util.Map;
import com.example.Languages;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;
import org.tartarus.snowball.*;
import org.tartarus.snowball.ext.*;


public class Stemmer extends ExtensionFunctionDefinition {

    
    @Override
    public StructuredQName getFunctionQName() {
        return new StructuredQName("ss", "https://endings.uvic.ca/staticSearch", "stem");
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[]{SequenceType.SINGLE_STRING, SequenceType.SINGLE_STRING};
    }

    @Override
    public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
        return SequenceType.SINGLE_STRING;
    }
    
    public SnowballStemmer getStemmer(String lang) throws Exception{
        try{
            String className = "org.tartarus.snowball.ext." + lang + "Stemmer";
        	Class stemClass = Class.forName(className);
            SnowballStemmer stemmer = (SnowballStemmer) stemClass.newInstance();
            return stemmer;  
        } catch(Exception e) {
            throw new Exception("No stemmer found");
        }
    }
    
    
    @Override
    public ExtensionFunctionCall makeCallExpression() {
        return new ExtensionFunctionCall() {
            @Override
            public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {
                String orig = ((StringValue)arguments[0]).getStringValue();
                String langCode = ((StringValue)arguments[1]).getStringValue();
                String lang = new Languages().get(langCode);
                try{                 
                    SnowballStemmer stemmer = getStemmer(lang);
                    stemmer.setCurrent(orig);
                    stemmer.stem();
                    return new StringValue(stemmer.getCurrent());
               } catch(Exception e){
                    throw new XPathException("Unable to stem for language " + langCode); 
               }
            }
        };
    }
}
