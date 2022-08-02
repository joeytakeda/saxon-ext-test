# `ss:stem#2` extension

An XSLT Extension Function that integrates Porter stemming.

## How to build

```
git checkout [[URL]]
ant
```

The extension will be in the `dist` directory; it does *not* include Saxon. 

## How to use

### 1. Register the extension with Saxon

Easiest way to do that is to use the configuration that is in the `dist/` folder:

```xml
<configuration edition="HE" xmlns="http://saxon.sf.net/ns/configuration">
     <resources>
          <extensionFunction>ca.uvic.endings.staticSearch.Stemmer</extensionFunction>
     </resources>
</configuration>
```


### 2. Run Saxon

Make sure the extension in your classpath. For example, to run the test from this directory:

```console
java -cp lib/saxon-he-10.jar:dist/extension.jar net.sf.saxon.Transform -config:dist/saxon_config.xsl -xsl:test.xsl -it:go
```

or from Ant using the `<java>` task:

```xml
<java classname="net.sf.saxon.Transform" failonerror="true" fork="true">
            <classpath>
                <path path="${extension.jar}"/>
                <path path="${saxon.jar}"/>
            </classpath>
            <arg line="-it:go"/>
            <arg line="-xsl:${test.dir}/test.xsl"/>
            <arg line="-config:saxon_config.xml"/>
        </java>
```

