#@ Usage - bungeerun Discord_Message def:Channel|Format|Message
Discord_Message:
  type: task
  definitions: Channel|Message
  script:
    - define Message <[Message].escaped.replace[`].with[']>
    - discord id:BehrBot Message channel:<[Channel]> "<[Message]>"
