require 'langchain'
require 'openai'
require 'gemini-ai'
require 'anthropic'
require 'dotenv'

def create_open_ai_model
  Langchain::LLM::OpenAI.new(
    api_key: ENV["OPENAI_API_KEY"],
    default_options: { temperature: 0.7, chat_model: "gpt-4o-mini" },
  )
end

def create_anthropic_model
  Langchain::LLM::Anthropic.new(
    api_key: ENV["ANTHROPIC_API_KEY"],
    default_options: { temperature: 0.7 },
  )
end

def create_google_model
  Langchain::LLM::GoogleGemini.new(
    api_key: ENV["GOOGLE_API_KEY"],
    default_options: { temperature: 0.7, chat_model: "gemini-1.5-flash" },
  )
end

Dotenv.load

llm = create_google_model

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
