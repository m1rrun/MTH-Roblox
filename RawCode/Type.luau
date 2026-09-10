local te = {}

export type api = {
	new: (id: string?, disableAutoClear: boolean?) -> handlerPublic,
}

export type handlerPublic = {
	read isAutoClear: boolean,
	read isEmpty: boolean,
	
	AddThread: (self: handlerPublic, id: string, thread: thread) -> handlerPublic,
	GetAutoCache: (self: handlerPublic, reMeta: boolean?) -> {[string]: thread},
	RemoveThread: (self: handlerPublic, id: string?) -> handlerPublic,
	CancelThread: (self: handlerPublic, id: string?) -> handlerPublic,
	CancelAllThreads: (self: handlerPublic) -> handlerPublic,
	Destroy: (self: handlerPublic) -> ()
}

export type handlerPrivate = handlerPublic & {
	rawCache: {[string]: thread},
	cache: {[string]: thread}
}

return te