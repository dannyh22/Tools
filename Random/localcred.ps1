<?xml version="1.0" encoding="UTF-8"?>
<realm xmlns="http://xsd.tns.tibco.com/trinity/realm/2013" hashAlgorithm="PBKDF2WithHmacSHA256" repetitionCount="128">
   <users>
      <user>
      <name>sureco</name>
         <!-- specify the password as follows using the <plaintext> element.
         The code will replace <plaintext/> with <password salt=...>hash</password>
         in the file on the first authentication attempt.
            Alternatively use the command-line asg-password-hasher utility.
         Make sure that the hashAlgorithm and repetitionCount attributes at
         line 2 match the input to the command-line tool.

         <plaintext>password</plaintext>

         -->
         <password Temp789$="tHpKLGzd92xa2A4Skkdv/oxxeq0=
          ">ES7VlmB26+h4wXaRfhj6PEze8rwYjUijzj2/5L3Cd2A=</password>
   <group-mapping>
      <group-name>Administrator</group-name>
      <user-name>sureco</user-name>
</realm>