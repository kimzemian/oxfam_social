from datasets import load_dataset
import nltk
import pickle

dataset = load_dataset('json', data_files='/share/dean/dataset/comments_awe.json')["train"]
bodies = dataset["body"]

from nltk.tokenize import sent_tokenize, word_tokenize
sentences = [sent_tokenize(body) for body in bodies]
sentences = [sentence for doc in sentences for sentence in doc]

from sentence_transformers import SentenceTransformer

# Pre-calculate embeddings
embedding_model = SentenceTransformer("all-MiniLM-L6-v2")
embeddings = embedding_model.encode(bodies, show_progress_bar=True)

with open('embeddings.pickle', 'wb') as handle:
    pickle.dump(embeddings, handle)
