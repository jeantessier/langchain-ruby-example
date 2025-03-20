require 'langchain'
require 'openai'
require 'gemini-ai'
require 'anthropic'
require 'dotenv'

def create_open_ai_model
  Langchain::LLM::OpenAI.new(
    api_key: ENV["OPENAI_API_KEY"],
    default_options: { temperature: 0.7, chat_model: ENV["OPENAI_MODEL"] },
  )
end

def create_anthropic_model
  Langchain::LLM::Anthropic.new(
    api_key: ENV["ANTHROPIC_API_KEY"],
    default_options: { temperature: 0.7, chat_model: ENV["ANTHROPIC_MODEL"] },
  )
end

def create_google_model
  Langchain::LLM::GoogleGemini.new(
    api_key: ENV["GOOGLE_API_KEY"],
    default_options: { temperature: 0.7, chat_model: ENV["GOOGLE_MODEL"] },
  )
end

def create_deepseek_model
  # Langchain::LLM::DeepSeek did not exist, as of 2025-03-03, when GenAI agents suggested it.
  Langchain::LLM::DeepSeek.new(
    api_key: ENV["DEEPSEEK_API_KEY"],
    default_options: { temperature: 0.7, chat_model: ENV["DEEPSEEK_MODEL"] },
  )
end

Dotenv.load

pos = ARGV.find_index("--model") || -1

llm = case ARGV[pos + 1]
      when "openai" then create_open_ai_model
      when "anthropic" then create_anthropic_model
      when "google" then create_google_model
      when "deepseek" then create_deepseek_model
      else create_open_ai_model
      end

# response = llm.embed(text: "Hello, world!")
# embedding = response.embedding
#
# puts embedding

messages = {
  parts: [
    { text: "Translate this user message to Spanish." },
    { text: "Hello, World!" },
  ]
}

response = llm.chat(messages: messages)

puts "Response"
puts "--------"
puts response

puts

puts "Chat Completion"
puts "---------------"
puts response.chat_completion
