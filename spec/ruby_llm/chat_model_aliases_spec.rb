# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyLLM::Chat do
  include_context 'with configured RubyLLM'

  it 'finds models by alias name' do
    # Core test - can we find a model using just its alias?
    chat = RubyLLM.chat(model: 'claude-haiku-4-5')
    expect(chat.model.id).to eq('claude-haiku-4-5')
    expect(chat.model.provider).to eq('anthropic')
  end

  it 'still supports exact model IDs' do
    # Backward compatibility check
    chat = RubyLLM.chat(model: 'claude-haiku-4-5-20251001')
    expect(chat.model.id).to eq('claude-haiku-4-5-20251001')
    expect(chat.model.provider).to eq('anthropic')
  end

  it 'finds models by alias and provider' do
    chat = RubyLLM.chat(model: 'claude-3-5-haiku', provider: :bedrock)
    expect(chat.model.id).to eq('anthropic.claude-3-5-haiku-20241022-v1:0')
    expect(chat.model.provider).to eq('bedrock')
  end

  it 'handles different provider prefixes correctly' do
    # Test that we can match models regardless of their provider prefix
    chat = RubyLLM.chat(model: 'claude-sonnet-4', provider: :bedrock)
    expect(chat.model.id).to eq('us.anthropic.claude-sonnet-4-20250514-v1:0')
    expect(chat.model.provider).to eq('bedrock')
  end

  it 'resolves gemini-3.5-flash-preview alias to the stable gemini-3.5-flash model' do
    chat_gemini = RubyLLM.chat(model: 'gemini-3.5-flash-preview', provider: :gemini)
    expect(chat_gemini.model.id).to eq('gemini-3.5-flash')
    expect(chat_gemini.model.provider).to eq('gemini')

    chat_openrouter = RubyLLM.chat(model: 'gemini-3.5-flash-preview', provider: :openrouter)
    expect(chat_openrouter.model.id).to eq('google/gemini-3.5-flash')
    expect(chat_openrouter.model.provider).to eq('openrouter')

    chat_vertex = RubyLLM.chat(model: 'gemini-3.5-flash-preview', provider: :vertexai)
    expect(chat_vertex.model.id).to eq('gemini-3.5-flash')
    expect(chat_vertex.model.provider).to eq('vertexai')
  end
end
