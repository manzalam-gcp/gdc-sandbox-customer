from google.cloud import translate
import google.auth
from google.auth.transport import requests
from google.api_core.client_options import ClientOptions
import requests as reqs
import os

audience = "https://translation.org-1.zone1.google.gdch.test:443"
api_endpoint="translation.org-1.zone1.google.gdch.test:443"

# os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "serviceaccountskey.json"
# os.environ["GRPC_DEFAULT_SSL_ROOTS_FILE_PATH"] = "trusted_certs.crt"

def translate_client(creds):
  opts = ClientOptions(api_endpoint=api_endpoint)
  return translate.TranslationServiceClient(credentials=creds, client_options=opts)

def main():
  creds = None
  try:
    creds, project_id = google.auth.default()
    creds = creds.with_gdch_audience(audience)
    sesh = reqs.Session()
    # Set the verify to be False to bypass the verification for cacert.
    # Should not use it in prod.

    sesh.verify = False
    req = requests.Request(session=sesh)
    creds.refresh(req)
    print("Got token: ")
    print(creds.token)
  except Exception as e:
    print("Caught exception" + str(e))
    raise e
  return creds
def translate_func(creds):
  tc = translate_client(creds)
  req = {"parent": "projects/translation-glossary-project", "source_language_code": "es", "target_language_code": "en", "contents": ["Hola, esto es una prueba"]}
  resp = tc.translate_text(req)
  print(resp)

if __name__=="__main__":
  creds = main()
  translate_func(creds)
