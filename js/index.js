import '../lib/js/javascript/base-stemmer.js';
import '../lib/js/javascript/english-stemmer.js' as Stemmer;

const ssStem = (word) => {
    Stemmer.stemWord(word);
}

