using EngActivator.APP.Dtos;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace EngActivator.APP.Services
{
    public class AppDictionary
    {
        private const int fuzzySearchTolerance = 2;
        private const int maxRecommendationCount = 5;
        private Dictionary<string, DictionaryEntry> _dictionary = new Dictionary<string, DictionaryEntry>();
        private List<string> _dictionaryKeys = new List<string>();

        public AppDictionary()
        {
            InitDictionary();
        }

        public DictionaryResponse SearchWord(string searchTerm)
        {
            var dictResponse = new DictionaryResponse();

            if (string.IsNullOrWhiteSpace(searchTerm))
            {
                return dictResponse;
            }

            var normalizedSearchTerm = searchTerm.ToLower().Trim();

            if (_dictionary.ContainsKey(normalizedSearchTerm))
            {
                dictResponse.DictionaryEntries.Add(_dictionary[normalizedSearchTerm]);
            }
            else
            {
                dictResponse.Recommendations = GetRecommendations(normalizedSearchTerm);
            }

            return dictResponse;
        }

        private List<string> GetRecommendations(string searchTerm)
        {
            var recommendations = new List<string>();

            foreach (var key in _dictionaryKeys)
            {
                var score = LevenshteinDistanceAlgorithm(searchTerm, key);

                if (score <= fuzzySearchTolerance)
                {
                    recommendations.Add(key);

                    if (recommendations.Count == maxRecommendationCount) break;
                }
            }

            return recommendations;
        }

        private void InitDictionary()
        {
            string fullPath = System.Reflection.Assembly.GetAssembly(typeof(AppDictionary)).Location;
            string theDirectory = Path.GetDirectoryName(fullPath);
            string filePath = Path.Combine(theDirectory, "Files", "dictionary.json");
            var dictionaryText = System.IO.File.ReadAllText(filePath);

            _dictionary = JsonConvert.DeserializeObject<Dictionary<string, DictionaryEntry>>(dictionaryText);

            _dictionaryKeys = _dictionary.Keys.ToList();
        }

        private int LevenshteinDistanceAlgorithm(string strA, string strB)
        {
            // calculates how many edits needs to be done, to get from string A to string B
            // https://en.wikipedia.org/wiki/Approximate_string_matching

            if (string.IsNullOrEmpty(strA)) return strB.Length;

            if (string.IsNullOrEmpty(strB)) return strA.Length;

            int strALength = strA.Length;
            int strBLength = strB.Length;
            int[,] matrix = new int[strALength + 1, strBLength + 1];

            // Initialize arrays.
            for (int i = 0; i <= strALength; matrix[i, 0] = i++)
            {
            }

            for (int j = 0; j <= strBLength; matrix[0, j] = j++)
            {
            }

            // Begin looping.
            for (int i = 1; i <= strALength; i++)
            {
                for (int j = 1; j <= strBLength; j++)
                {
                    // Compute cost.
                    int cost = (strB[j - 1] == strA[i - 1]) ? 0 : 1;

                    matrix[i, j] = Math.Min(
                        Math.Min(matrix[i - 1, j] + 1, matrix[i, j - 1] + 1),
                        matrix[i - 1, j - 1] + cost
                    );
                }
            }

            // Return cost.
            return matrix[strALength, strBLength];
        }
    }
}
