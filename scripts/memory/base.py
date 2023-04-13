"""Base class for memory providers."""
import abc
from config import AbstractSingleton, Config
import openai
cfg = Config()

# https://platform.openai.com/docs/models/model-endpoint-compatibility
def get_ada_embedding(text):
    text = text.replace("\n", " ")
    # Here it seems to be an bug, even if it says false it still takes as true
    # Changing
    if cfg.use_azure == True:
        return openai.Embedding.create(input=[text], engine=cfg.azure_embeddigs_deployment_id, model="text-embedding-ada-002")["data"][0]["embedding"]
    else:
        return openai.Embedding.create(input=[text], model="text-embedding-ada-002")["data"][0]["embedding"]


class MemoryProviderSingleton(AbstractSingleton):
    @abc.abstractmethod
    def add(self, data):
        pass

    @abc.abstractmethod
    def get(self, data):
        pass

    @abc.abstractmethod
    def clear(self):
        pass

    @abc.abstractmethod
    def get_relevant(self, data, num_relevant=5):
        pass

    @abc.abstractmethod
    def get_stats(self):
        pass
