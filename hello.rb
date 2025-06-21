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

prompt = Langchain::Prompt::PromptTemplate.new(template: "Tell me a {adjective} joke about {content}.", input_variables: ["adjective", "content"])
prompt_text = prompt.format(adjective: "funny", content: "chickens") # "Tell me a funny joke about chickens."

messages = [
  { role: "user", content: prompt_text },
]

response = llm.chat(messages: messages)

puts "Response"
puts "--------"
puts response

puts

puts "Completion"
puts "----------"
puts response.completion

puts

puts "Chat Completion"
puts "---------------"
puts response.chat_completion
