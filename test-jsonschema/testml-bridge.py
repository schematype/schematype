import os
import json
from jsonschema import validate as check

from testml.bridge import TestMLBridge as Base

class TestMLBridge(Base):
  def validate(self, jsc, data):
    schema = json.loads(jsc)
    instance = json.loads(data)
    try:
      check(instance=instance, schema=schema)
    except:
      return "false"
    return "true"
